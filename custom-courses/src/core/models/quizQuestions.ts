export interface QuizQuestion{
    id:string;
    quiz_id:string;
    question:string;
    question_type:'multiple_choice' | 'true_false' | 'short_answer';
    points:number;
    order_index:number;
    created_at:Date;
    updated_at:Date;
}

export const createQuizQuestion = (data: Partial<QuizQuestion>): QuizQuestion => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    quiz_id: data.quiz_id || '',
    question: data.question || '',
    question_type: data.question_type || 'multiple_choice',
    points: data.points ?? 0,
    order_index: data.order_index ?? 0,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});