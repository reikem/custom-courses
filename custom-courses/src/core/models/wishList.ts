export interface WishList{
    id: string;
    user_id: string;
    course_id: string;
    created_at: Date;
}

export const createWishList = (data: Partial<WishList>): WishList => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    course_id: data.course_id ?? '',
    created_at: data.created_at || new Date(),
});