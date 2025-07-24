export interface Comment{
    id:string;
    user_id:string;
    course_id?:string;
    lesson_id?:string;
    parent_id?:string;
    content:string;
    is_pinned:boolean;
    pinned_at?:Date;
    pinned_by?:string;
    like_count:number;
    created_at:Date;
    updated_at:Date;
}

export const createComment = (data: Partial<Comment>): Comment => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    course_id: data.course_id ?? '',
    lesson_id: data.lesson_id ?? '',
    parent_id: data.parent_id ?? '',
    content: data.content || '',
    is_pinned: data.is_pinned ?? false,
    pinned_at: data.pinned_at || new Date(),
    pinned_by: data.pinned_by ?? '',
    like_count: data.like_count ?? 0,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});