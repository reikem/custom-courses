export interface QuizzUserAnswer {
    id: string;
    attempt_id: string;
    question_id: string;
    answer_text?: string;
    selected_options?: string; 
    is_correct?: boolean;
    points_earned?: number; 
    created_at: Date;
}
export const createQuizzUserAnswer = (data: Partial<QuizzUserAnswer>): QuizzUserAnswer => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    attempt_id: data.attempt_id || '',
    question_id: data.question_id || '',
    answer_text: data.answer_text || '',
    selected_options: data.selected_options || '',
    is_correct: data.is_correct ?? false,
    points_earned: data.points_earned ?? 0,
    created_at: data.created_at || new Date(),
});