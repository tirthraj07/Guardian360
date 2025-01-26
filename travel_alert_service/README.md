
# Travel Alert Service

The **Travel Alert Service** helps users track their locations, manage friend requests, and create or view safe places. The service provides location tracking functionality, friends' location updates, and a way to manage friend requests. It also allows users to set and view safe places for additional security.

## Start Command

To start the application, run the following command:

```bash
uvicorn app.main:app --reload --port 8000 --host 0.0.0.0
```

This command will launch the FastAPI server with hot reload and open the service at `http://0.0.0.0:8000`.

---

## Routes Information

### **Friend Routes**

#### `/friends/available` (POST)
- **Description**: Fetch the available friends for a user.
- **Request Body**: `FriendsAvailableCheck` (Contains `userID`)
- **Response**: List of available friends (`FriendsAvailableList`)

#### `/friends/request` (POST)
- **Description**: Send friend requests to multiple users.
- **Request Body**: `FriendRequest` (Contains `userID` and `friend_requests` list)
- **Response**: Success or error message.

#### `/friends/accept-request` (POST)
- **Description**: Accept friend requests from users.
- **Request Body**: `FriendRequest` (Contains `userID` and `friend_requests` list)
- **Response**: Success or error message.

#### `/friends/pending-requests` (POST)
- **Description**: Fetch all pending friend requests for a user.
- **Request Body**: `SeeAvaialableFriendRequest` (Contains `userID`)
- **Response**: List of pending friend requests.

---

### **Location Routes**

#### `/location/{userID}` (POST)
- **Description**: Track the location of a user.
- **Request Body**: `UserLocationData` (Contains latitude, longitude, timestamp, and optional travel details)
- **Response**: Success or error message.

#### `/location/{userID}/friends` (GET)
- **Description**: Fetch the locations of the user's friends.
- **Response**: List of friends' locations.

---

### **Safe Place Routes**

#### `/safe-places/create` (POST)
- **Description**: Create a safe place for a user.
- **Request Body**: `KnownPlaceCreate` (Contains userID, location details, and place information)
- **Response**: Success message with HTTP status code 201.

#### `/safe-places/{userID}` (GET)
- **Description**: Get all safe places created by a user.
- **Response**: List of the user's safe places.

---

## Installation

To install the necessary dependencies, run the following command:

```bash
pip install -r requirements.txt
```

## Environment Variables

Make sure to set up the necessary environment variables for your database and other services in a `.env` file.
