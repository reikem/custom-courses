export interface Lesson {
    id: string;
    course_id: string;
    title: string;
    description?: string;
    video_url?: string;
    duration: number;
    order_index: number;
    is_free: boolean;
    is_published: boolean;
    created_at: Date;
    updated_at: Date;
  }
  
  export const createLesson = (data: Partial<Lesson>): Lesson => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    course_id: data.course_id || '',
    title: data.title || '',
    description: data.description  || '',
    video_url: data.video_url  || '',
    duration: data.duration ?? 0,
    order_index: data.order_index ?? 0,
    is_free: data.is_free ?? false,
    is_published: data.is_published ?? true,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
  });
  