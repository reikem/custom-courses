export interface UserPreference {
    id:string;
    user_id:string;
    theme:string;
    language:string;
    email_notifications:boolean;
    push_notifications:boolean;
    created_at:Date;
    updated_at:Date;
}

export const createUserPreference=(data: Partial<UserPreference>): UserPreference => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    theme: data.theme || 'light',
    language: data.language || 'en',
    email_notifications: data.email_notifications ?? true,
    push_notifications: data.push_notifications ?? true,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});