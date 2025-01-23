# UserService -> UserRepository -> users table
#             -> FriendRelationRepository -> friend_relations table

from app.repository.user_repository import UserRepository
from app.repository.friend_relation_repository import FriendRelationRepository
from app.repository.user_notification_preferences_repository import UserNotificationPreferencesRepository

class UserService:
    @staticmethod
    def get_all_users():
        return UserRepository.get_all_users()
    
    @staticmethod
    def get_user_by_id(user_id):
        return UserRepository.get_user_by_id(user_id)
    
    @staticmethod
    def get_users_by_ids(user_ids):
        return UserRepository.get_users_by_ids(user_ids)
    
    @staticmethod
    def get_friend_ids(userID):
        return FriendRelationRepository.get_friend_ids(userID)
    
    @staticmethod
    def get_friends(user_id):
        friend_ids = FriendRelationRepository.get_friend_ids(user_id)
        friends = UserService.get_users_by_ids(friend_ids)
        return friends 
    