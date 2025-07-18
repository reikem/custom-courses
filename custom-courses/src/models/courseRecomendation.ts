export interface CourseRecommendation {
    id: string;
    user_id: string;
    course_id: string;
    score: number; 
    reason?: string;
    generated_at: Date;
}

export const createCourseRecommendation = (data: Partial<CourseRecommendation>): CourseRecommendation => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id || '',
    course_id: data.course_id || '',
    score: data.score ?? 0,
    reason: data.reason || '',
    generated_at: data.generated_at || new Date(),
});