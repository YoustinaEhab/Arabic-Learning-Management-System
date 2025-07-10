# LMS API Documentation

## Authentication

All protected endpoints require the `Authorization` header with a valid JWT token (without "Bearer" prefix).

### Authentication Endpoints

```http
POST /login
Content-Type: application/json

{
    "email": "user@example.com",
    "password": "password123"
}
```

```http
POST /signup
Content-Type: application/json

{
    "name": "User Name",
    "email": "user@example.com",
    "password": "password123",
    "role": "student" // or "teacher"
}
```

## Quiz Attempts

### Submit Quiz Attempt (for Authenticated Student)

```http
POST /quiz-attempts
Headers:
  Authorization: <token>
Content-Type: application/json

{
    "quiz_name": "quiz1-history",
    "time_taken_seconds": 300,
    "responses": [
        {
            "question": "ما هي الديانة التي انتشرت في الجزيرة العربية؟",
            "selected_answer": "الحنيفية"
        }
    ]
}
```

### View My Attempts (for Authenticated Student)

```http
GET /quiz-attempts/my-attempts
Headers:
  Authorization: <token>
```


### Get Quiz Statistics (Teachers Only)

```http
GET /quiz-attempts/statistics/{quiz_name}
Headers:
  Authorization: <teacher_token>

Response:
{
    "total_attempts": 10,
    "average_score": 75.5,
    "highest_score": 100.0,
    "lowest_score": 40.0,
    "average_time": 300.5
}
```

### Get Student Report (Teachers Only)

```http
GET /quiz-attempts/student-report/{quiz_name}/{student_id}
Headers:
  Authorization: <teacher_token>

Response:
{
    "total_attempts": 3,
    "best_score": 90.0,
    "average_score": 85.0,
    "latest_score": 88.0,
    "average_time": 250.5
}
```

### Get All Student Scores (Teachers Only)

```http
GET /quiz-attempts/quiz-scores/{quiz_name}
Headers:
  Authorization: <teacher_token>

Response:
[
    {
        "student_name": "Student Name",
        "total_attempts": 3,
        "best_score": 90.0
    }
]
```

## Teacher Endpoints

## 📋 Quiz Management

### 1.Generate a new quiz

```text
POST /generate-quiz

Headers:
  Authorization: Bearer YOUR_TEACHER_TOKEN
  Content-Type: multipart/form-data

Form Data:
- file: YOUR_PDF_FILE
- quiz_name: "quiz1-history"
- num_response_questions: 5
```

---

### 2.Delete a quiz

```text
DELETE /delete-quiz/{quiz_name}

Headers:
  Authorization: Bearer YOUR_TEACHER_TOKEN
```

---

## Public Endpoints

### Quiz Access

1. List all quizzes

```http
GET /get-quizzes

Response:
[
    {
        "quiz_name": "quiz1-history",
        "paragraphs_qa_pairs": [
            {
                "question": "Question text?",
                "answer": "Correct answer",
                "options": ["Option 1", "Option 2", "Option 3", "Option 4"]
            }
            // ... more questions
        ]
    }
    // ... more quizzes
]
```

2. Get specific quiz

```http
GET /get-quiz/{quiz_name}

Response:
{
    "quiz_name": "quiz1-history",
    "paragraphs_qa_pairs": [
        {
            "question": "Question text?",
            "answer": "Correct answer",
            "options": ["Option 1", "Option 2", "Option 3", "Option 4"]
        }
        // ... more questions
    ]
}
```


## Profile Endpoints

### 1. Get Current User Profile

**GET** `/profile/me`

```
Authorization: your_jwt_token_here
```

Returns the current user's profile information.

### 2. Update Current User Profile

**PUT** `/profile/me`

```
Authorization: your_jwt_token_here
```

Updates the current user's profile information. All fields are optional.

**Request Body:**

- All fields in the update request are optional - only provided fields will be updated

```json
{
  "name": "John Doe Updated",
  "phone": "+1234567890",
  "profile_img": "https://example.com/new-profile.jpg",
  "password": "newpassword123"
}
```


## Notes

- The `email` and `role` fields cannot be updated through this endpoint
- If a new password is provided, it will be hashed before storage
- The user must be authenticated to access these endpoints

Common error status codes:

- 401: Unauthorized (invalid or missing token)
- 403: Forbidden (insufficient role permissions)
- 404: Not Found
- 400: Bad Request (invalid input)
- 500: Internal Server Error

## Notes

1. All timestamps are in UTC
2. Score percentages are from 0.0 to 100.0
3. Time values are in seconds
4. The `Authorization` header should contain just the JWT token (no "Bearer" prefix)
