export interface UserActivity{
    id:string;
    user_id:string;
    activity_type:string; // e.g., 'lesson_progress', 'achievement', 'wishlist',
    activity_data: Record<string, any>; // JSON object to store activity-specific data
    created_at: Date;
}

export const createUserActivity = (data: Partial<UserActivity>): UserActivity => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    activity_type: data.activity_type ?? '',
    activity_data: data.activity_data || {},
    created_at: data.created_at || new Date(),
});