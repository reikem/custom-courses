export interface UserInteraction {
    id: string;
    user_id: string;
    course_id: string;
    interaction_type: 'view' | 'comment' | 'like' | 'share';
    content_id?: string; 
    created_at: Date;
}

export const createUserInteraction = (data: Partial<UserInteraction>): UserInteraction => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id || '',
    course_id: data.course_id || '',
    interaction_type: data.interaction_type || 'view',
    content_id: data.content_id,
    created_at: data.created_at || new Date(),
});