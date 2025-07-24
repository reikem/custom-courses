export interface Rating{
    id: string;
    user_id: string;
    course_id: string;
    rating: number;
    review?: string; 
    created_at: Date;
    updated_at: Date;
}

export const createRating = (data: Partial<Rating>): Rating => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    course_id: data.course_id ?? '',
    rating: data.rating ?? 0,
    review: data.review ?? '',
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});