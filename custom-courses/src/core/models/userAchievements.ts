export interface UserAchievements {
    id:string;
    user_id:string;
    achievement_id:string;
    achieved_at: Date;
    is_active: boolean;
}
export const createUserAchievement = (data: Partial<UserAchievements>): UserAchievements => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    achievement_id: data.achievement_id ?? '',
    achieved_at: data.achieved_at || new Date(),
    is_active: data.is_active ?? true,
});