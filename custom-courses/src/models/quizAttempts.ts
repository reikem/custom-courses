export interface QuizAttempt {
    id:string;
    quiz_id:string;
    user_id:string;
    attempt_no:number;
    started_at:Date;
    completed_at?:Date;
    score:number; 
    max_score:number; 
    passed:boolean;
    answers: Record<string, any>; // key-value pairs for question_id and answer
}

export const createQuizAttempt = (data: Partial<QuizAttempt>): QuizAttempt => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    quiz_id: data.quiz_id || '',
    user_id: data.user_id || '',
    attempt_no: data.attempt_no ?? 1,
    started_at: data.started_at || new Date(),
    completed_at: data.completed_at,
    score: data.score ?? 0,
    max_score: data.max_score ?? 0,
    passed: data.passed ?? false,
    answers: data.answers || {},
});