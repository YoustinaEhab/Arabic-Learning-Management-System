# Arabic-Learning-Management-System

An AI-powered mobile application designed to personalize Arabic-language education. The system assists teachers with automatic quiz generation, evaluates student performance, and recommends personalized resources based on student weaknesses. With deep integration of NLP, recommendation systems, and mobile technologies, ALMS enables a smarter and more adaptive educational experience.

## 📑 Table of Contents
- [Demo Video](#demo-video)  
- [Technologies Used](#technologies-used)  
- [System Architecture](#system-architecture)  
- [NLP Models](#nlp-models)  
- [Recommendation System](#recommendation-system)  
- [Evaluation Results](#evaluation-results)  

## Demo Video
[![Demo Video](Assets/Demo.JPG)](https://drive.google.com/file/d/1f0qpaHTPitejhdLQcxu6PzGgE9HQCYYW/view?usp=drive_link)

## 🛠️ Technologies Used

**📱 Mobile App:**  
Flutter & Dart: Cross-platform mobile development

**⚙️ Backend:**  
- Python + FastAPI: RESTful API server for model endpoints  
- Google Colab / Kaggle Notebooks: Model hosting and inference

**🤖 NLP & AI:**  
- Hugging Face Transformers, PyTorch: Core NLP model infrastructure  
- AraT5, AraBART, mT5: Arabic question generation  
- YouTube API, FAISS, Sentence Transformers: Semantic search and resource ranking

## 🧩 System Architecture

[![System Architecture](Assets/System Architecture.JPG)](Assets/System Architecture.JPG)

**📱 Presentation Layer**

* **Mobile App (Flutter):** Interface for teachers and students to take quizzes, view progress, and receive resource recommendations.
* **Authentication:** Role-based login system for secure access.
* **Material & Progress Management:** Enables users to view course content and track performance over time.

**🧠 Logic Layer**

* **Quiz Generator:** Automatically creates Arabic MCQs using models like AraT5, AraBART, and mT5 from uploaded course PDFs.
* **Performance Tracker:** Analyzes quiz results to identify weak topics and deliver real-time feedback.
* **Resource Recommender:**

  * **Option 1:** YouTube API + Sentence Transformer for video recommendations.
  * **Option 2:** FAISS Vector DB + Arabic EKB dataset for relevant text snippets.

**🗂️ Data Layer**

* **User Database:** Stores user info, profile data, and roles.
* **Assessment Storage:** Saves quiz templates, attempts, and grades.
* **Educational Content:** Stores PDFs, YouTube links, and Q\&A data for learning and evaluation.
