export interface LessonProgress{
    id:string;
    user_id:string;
    lesson_id:string;
    completed:boolean;
    completed_at?:Date;
    watch_time:number;
    created_at:Date;
    updated_at:Date;
}

export const createLessonProgress = (data: Partial<LessonProgress>): LessonProgress => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    lesson_id: data.lesson_id ?? '',
    completed: data.completed ?? false,
    completed_at: data.completed_at || new Date(),
    watch_time: data.watch_time ?? 0,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});