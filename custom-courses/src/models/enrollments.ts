export interface Enrollment {
    id: string;
    user_id: string;
    course_id: string;
    enrolled_at: Date;
    completed_at?: Date;
    progress: number;
    last_accessed_at?: Date;
    is_active: boolean;
  }
  
  export const createEnrollment = (data: Partial<Enrollment>): Enrollment => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    course_id: data.course_id ?? '',
    enrolled_at: data.enrolled_at || new Date(),
    completed_at: data.completed_at || new Date(),
    progress: data.progress ?? 0,
    last_accessed_at: data.last_accessed_at || new Date(),
    is_active: data.is_active ?? false,
  });
  