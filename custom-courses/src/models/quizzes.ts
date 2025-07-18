export interface Quiz{
    id:string;
    course_id?:string;
    lesson_id?:string;
    title:string;
    description?:string;
    time_limit?:number; //in seconds
    max_attempts?:number;
    passing_score?:number; //percentage
    is_published:boolean;
    randomize_questions:boolean;
    show_correct_answers:boolean;
    created_at:Date;
    updated_at:Date;
}

export const createQuiz = (data: Partial<Quiz>): Quiz => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    course_id: data.course_id ?? '',
    lesson_id: data.lesson_id ?? '',
    title: data.title || '',
    description: data.description || '',
    time_limit: data.time_limit ?? 0,
    max_attempts: data.max_attempts ?? 1,
    passing_score: data.passing_score ?? 0,
    is_published: data.is_published ?? false,
    randomize_questions: data.randomize_questions ?? false,
    show_correct_answers: data.show_correct_answers ?? false,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});