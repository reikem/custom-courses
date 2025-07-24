export interface QuizOptions {
    id:string;
    quiz_id:string;
    option_text:string;
    is_correct:boolean;
    order_index:number;
    created_at:Date;
    updated_at:Date;
}

export const createQuizOption = (data: Partial<QuizOptions>): QuizOptions => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    quiz_id: data.quiz_id || '',
    option_text: data.option_text || '',
    is_correct: data.is_correct ?? false,
    order_index: data.order_index ?? 0,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});