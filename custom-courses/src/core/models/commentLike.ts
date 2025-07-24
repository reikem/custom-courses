export interface CommentLike{
    id: string;
    user_id: string;
    comment_id: string;
    created_at: Date;
}
export const createCommentLike = (data: Partial<CommentLike>): CommentLike => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    comment_id: data.comment_id ?? '',
    created_at: data.created_at || new Date(),
});