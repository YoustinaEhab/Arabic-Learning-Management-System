from googleapiclient.discovery import build
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# YouTube API setup
API_KEY = "AIzaSyCtmWaDQ5yvzmImmDhjnwNXgrsh5YphrnU"  # For real projects, use env vars or config
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION, developerKey=API_KEY)

# Load multilingual model that works well with Arabic
model = SentenceTransformer('intfloat/multilingual-e5-large-instruct')

def search_youtube_videos(query, max_results=5):
    request = youtube.search().list(
        q=query,
        part="snippet",
        type="video",
        maxResults=max_results,
        relevanceLanguage="ar",
        videoCategoryId="27"
    )
    response = request.execute()
    return response.get("items", [])

def format_video_results(videos):
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

def identify_weak_areas(student_performance, threshold=0.7):
    weak_areas = []
    for topic, performance in student_performance.items():
        accuracy = performance["correct"] / performance["total"]
        if accuracy <= threshold:
            weak_areas.append(topic)
    return weak_areas

def rank_resources_with_transformers(query, documents):
    embeddings = model.encode([query] + documents)
    query_vector = embeddings[0].reshape(1, -1)
    doc_vectors = embeddings[1:]
    similarities = cosine_similarity(query_vector, doc_vectors)
    return similarities[0]

def recommend_youtube_resources(weak_areas, max_results=5):
    recommendations = {}
    for area in weak_areas:
        videos = search_youtube_videos(area, max_results)
        formatted_videos = format_video_results(videos)

        if formatted_videos:
            documents = [video["title"] + " " + video["description"] for video in formatted_videos]
            similarities = rank_resources_with_transformers(area, documents)
            ranked_videos = [
                {"url": formatted_videos[i]["url"], "similarity": float(sim * 100)}
                for i, sim in sorted(
                    enumerate(similarities),
                    key=lambda x: float(x[1]) * 100,
                    reverse=True
                )
            ]
        else:
            ranked_videos = []

        recommendations[area] = ranked_videos

    return recommendations 