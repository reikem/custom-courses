export interface Notification {
    id:string;
    user_id:string;
    title:string;
    message:string;
    type:'info' | 'warning' | 'error' | 'success'; 
    read:boolean;
    action_url?:string;
    created_at: Date;
}

export const createNotification = (data: Partial<Notification>): Notification => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    title: data.title || '',
    message: data.message || '',
    type: data.type || 'info',
    read: data.read ?? false,
    action_url: data.action_url || '',
    created_at: data.created_at || new Date(),
});