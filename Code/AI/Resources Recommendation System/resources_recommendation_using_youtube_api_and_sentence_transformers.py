# -*- coding: utf-8 -*-
"""Resource Recommendation Using YouTube API and Sentence Transformers.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1GhtTquU5ROAyMuSFLhx30By211TwS_4A
"""

!pip install -U sentence-transformers

from googleapiclient.discovery import build

# YouTube API setup
API_KEY = "AIzaSyCtmWaDQ5yvzmImmDhjnwNXgrsh5YphrnU"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION, developerKey=API_KEY)

def search_youtube_videos(query, max_results=5):
    """
    Search YouTube for videos related to the query.
    :param query: Search query (e.g., "Arabic verb conjugation")
    :param max_results: Maximum number of results to return
    :return: List of video resources
    """
    request = youtube.search().list(
        q=query,
        part="snippet",
        type="video",
        maxResults=max_results,
        relevanceLanguage="ar",  # Prioritize Arabic content
        #videoDuration="medium",  # Filter for medium-length videos
        videoCategoryId="27"     # Education category
    )
    response = request.execute()
    return response.get("items", [])

def format_video_results(videos):
    """
    Format YouTube video results for display.
    :param videos: List of video resources from YouTube API
    :return: List of formatted video details
    """
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

def identify_weak_areas(student_performance, threshold=0.5):
    """
    Identify weak areas based on student performance.
    :param student_performance: Dictionary of student performance data
    :param threshold: Accuracy threshold to consider a topic weak
    :return: List of weak areas
    """
    weak_areas = []
    for topic, performance in student_performance.items():
        accuracy = performance["correct"] / performance["total"]
        if accuracy < threshold:
            weak_areas.append(topic)
    return weak_areas

from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# model = SentenceTransformer('intfloat/multilingual-e5-large')
model = SentenceTransformer('intfloat/multilingual-e5-large-instruct')

# model = SentenceTransformer('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')
# model = SentenceTransformer('paraphrase-multilingual-mpnet-base-v2')
# model = SentenceTransformer('distiluse-base-multilingual-cased-v2')
def rank_resources_with_transformers(query, documents):
    """
    Ranks documents using Sentence Transformers.
    :param query: A string (weak topic)
    :param documents: A list of strings (e.g. YouTube titles + descriptions)
    :return: List of similarity scores
    """
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

            # Switch here between TF-IDF and Transformers
            similarities = rank_resources_with_transformers(area, documents)
            # or
            #similarities = rank_resources_with_tfidf(area, documents)

            ranked_videos = sorted(
                [
                    {"video": formatted_videos[i], "similarity": sim * 100}
                    for i, sim in enumerate(similarities)
                ],
                key=lambda x: x["similarity"],
                reverse=True
            )

            for video in ranked_videos:
                title = video["video"]["title"]
                description = video["video"]["description"]
                thumbnail = video["video"]["thumbnail"]
                url = video["video"]["url"]
        else:
            ranked_videos = []

        recommendations[area] = ranked_videos

    return recommendations

# Example student performance data based on lesson of each paragraph
student_performance = {
    "ممالك اليمن": {"correct": 2, "total": 10},  # 20% accuracy
    "مدن الحجاز": {"correct": 7, "total": 10},          # 70% accuracy
    "أهل مكة قبل الإسلام": {"correct": 4, "total": 10},       # 40% accuracy
}

# Identify weak areas
weak_areas = identify_weak_areas(student_performance)
print("Weak Areas:", weak_areas)

# Recommend YouTube videos
recommendations = recommend_youtube_resources(weak_areas)

# Display recommendations
for area, videos in recommendations.items():
    print(f"\nRecommended videos for {area}:")
    for video in videos:
        info = video['video']
        score = round(video['similarity'], 2)
        print(f"- {info['title']} ({score:.2f}% match): {info['url']}")
        #print(f"- {video['title']}: {video['url']}")

import csv

def save_recommendations_to_csv(recommendations, filename="youtube_recommendations.csv"):
    with open(filename, mode="w", encoding="utf-8", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Topic", "Title", "Description", "Thumbnail", "URL", "Similarity (%)"])

        for topic, videos in recommendations.items():
            for video in videos:
                info = video['video']
                writer.writerow([
                    topic,
                    info['title'],
                    info['description'],
                    info['thumbnail'],
                    info['url'],
                    round(video['similarity'], 2)
                ])
def save_URLrecommendations_to_csv(recommendations, filename="youtube_URLrecommendations.csv"):
    with open(filename, mode="w", encoding="utf-8", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["URL"])

        for topic, videos in recommendations.items():
            for video in videos:
                info = video['video']
                writer.writerow([
                    info['url'],
                ])
save_recommendations_to_csv(recommendations)
save_URLrecommendations_to_csv(recommendations)

import joblib

def save_recommendations_to_joblib(recommendations, filename="youtube_recommendations.joblib"):
    joblib.dump(recommendations, filename)
save_recommendations_to_joblib(recommendations)
loaded_recommendations = joblib.load("youtube_recommendations.joblib")
print(loaded_recommendations)

urls_only = {
    area: [video['video']['url'] for video in videos]
    for area, videos in recommendations.items()
}
joblib.dump(urls_only, "youtube_recommendations_urls.joblib")
loaded_urls = joblib.load("youtube_recommendations_urls.joblib")
print(loaded_urls)