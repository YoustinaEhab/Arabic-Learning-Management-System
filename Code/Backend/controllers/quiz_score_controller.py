from models.quiz_score import QuizScore, TopicPerformance
from schemas.quiz_score_schema import QuizScoreRequest, ResourceRecommendation
from typing import List, Dict
from googleapiclient.discovery import build
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import os

# YouTube API setup
API_KEY = "AIzaSyCtmWaDQ5yvzmImmDhjnwNXgrsh5YphrnU"  # Consider moving this to environment variables
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION, developerKey=API_KEY)
model = SentenceTransformer('intfloat/multilingual-e5-large-instruct')

def identify_weak_areas(topic_performance: Dict[str, TopicPerformance], threshold: float = 0.5) -> List[str]:
    """Identify topics where performance is below threshold."""
    weak_areas = []
    for topic, performance in topic_performance.items():
        accuracy = performance.correct / performance.total
        if accuracy < threshold:
            weak_areas.append(topic)
    return weak_areas

def search_youtube_videos(query: str, max_results: int = 5) -> List[Dict]:
    """Search YouTube for educational videos."""
    try:
        request = youtube.search().list(
            q=query,
            part="snippet",
            type="video",
            maxResults=max_results,
            relevanceLanguage="ar",
            videoCategoryId="27"  # Education category
        )
        response = request.execute()
        return response.get("items", [])
    except Exception as e:
        print(f"YouTube API error: {str(e)}")
        return []

def format_video_results(videos: List[Dict]) -> List[Dict]:
    """Format YouTube video results."""
    formatted_results = []
    for video in videos:
        video_id = video["id"]["videoId"]
        title = video["snippet"]["title"]
        description = video["snippet"]["description"]
        thumbnail = video["snippet"]["thumbnails"]["default"]["url"]
        formatted_results.append({
            "title": title,
            "description": description,
            "thumbnail": thumbnail,
            "url": f"https://www.youtube.com/watch?v={video_id}"
        })
    return formatted_results

def rank_resources_with_transformers(query: str, documents: List[str]) -> List[float]:
    """Rank documents using sentence transformers."""
    try:
        embeddings = model.encode([query] + documents)
        query_vector = embeddings[0].reshape(1, -1)
        doc_vectors = embeddings[1:]
        similarities = cosine_similarity(query_vector, doc_vectors)
        return similarities[0]
    except Exception as e:
        print(f"Ranking error: {str(e)}")
        return [0.0] * len(documents)

async def process_quiz_score(quiz_score_request: QuizScoreRequest) -> QuizScore:
    """Process quiz score and generate recommendations."""
    # Convert topic performance to the correct format
    topic_performance = {
        topic: TopicPerformance(**perf.dict())
        for topic, perf in quiz_score_request.topic_performance.items()
    }
    
    # Identify weak areas
    weak_areas = identify_weak_areas(topic_performance)
    
    # Generate recommendations for weak areas
    recommendations = {}
    for area in weak_areas:
        videos = search_youtube_videos(area)
        formatted_videos = format_video_results(videos)
        
        if formatted_videos:
            documents = [f"{video['title']} {video['description']}" for video in formatted_videos]
            similarities = rank_resources_with_transformers(area, documents)
            
            ranked_videos = []
            for i, (video, similarity) in enumerate(zip(formatted_videos, similarities)):
                video["similarity"] = float(similarity * 100)
                ranked_videos.append(video)
            
            ranked_videos.sort(key=lambda x: x["similarity"], reverse=True)
            recommendations[area] = ranked_videos
    
    # Create and save quiz score document
    quiz_score = QuizScore(
        user_id=quiz_score_request.user_id,
        quiz_name=quiz_score_request.quiz_name,
        topic_performance=topic_performance,
        recommended_resources=recommendations
    )
    await quiz_score.insert()
    
    return quiz_score

async def get_quiz_score(user_id: str, quiz_name: str) -> QuizScore:
    """Retrieve quiz score and recommendations."""
    return await QuizScore.find_one(
        QuizScore.user_id == user_id,
        QuizScore.quiz_name == quiz_name
    ) 