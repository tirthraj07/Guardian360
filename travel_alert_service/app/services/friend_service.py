from fastapi import HTTPException, status
from app.models.friend_models import FriendsAvailable
from app.repository.user_repository import UsersRepository
from app.repository.friends_relations_repository import FriendRelationsRepository  # Import friend repository
from app.repository.pending_friends_requests_repository import PendingFriendRequestsRepository
class FriendService:
    @staticmethod
    def fetch_available_friends(userID):
        try:
            users = UsersRepository.get_available_friends(userID)
            friends = [
                FriendsAvailable(
                    userID=user['userID'],
                    email=user['email'],
                    first_name=user['first_name'],
                    last_name=user['last_name'],
                    phone_no=user['phone_no'],
                    profile_pic_location=user['profile_pic_location']
                ) for user in users
            ]

            return {"available_friends": friends}
        
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred: {str(e)}"
            )

    @staticmethod
    def send_friend_requests(userID, requested_user_ids):
        try:
            for receiverID in requested_user_ids:
                try:
                    PendingFriendRequestsRepository.add_friend_request(userID, receiverID)  # Use repository class
                except Exception as e:
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail=f"Error adding friend request for user {receiverID}: {str(e)}"
                    )

            return {"message": "Friend request sent successfully"}
        
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred: {str(e)}"
            )

    @staticmethod
    def accept_friend_requests(userID, accepted_user_ids):
        try:
            for receiverID in accepted_user_ids:
                try:
                    FriendRelationsRepository.add_friend(receiverID, userID)  # Use repository class
                except Exception as e:
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail=f"Error adding friend request for user {receiverID}: {str(e)}"
                    )

            return {"message": "Friend added successfully"}
        
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred: {str(e)}"
            )

    @staticmethod
    def fetch_pending_requests(userID):
        try:
            pending_requests = PendingFriendRequestsRepository.get_pending_requests(userID)  # Use repository class

            if not pending_requests:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="No pending friend requests found"
                )

            return {"pending_requests": pending_requests}
        
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred: {str(e)}"
            )
