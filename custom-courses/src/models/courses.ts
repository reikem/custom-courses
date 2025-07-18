export interface Course {
    id: string;
    title: string;
    description: string;
    short_description?: string;
    thumbnail?: string;
    video_url?: string;
    price: number;
    original_price?: number;
    level: 'beginner' | 'intermediate' | 'advanced';
    duration: number;
    language: string;
    status: 'draft' | 'published' | 'archived';
    author_id: string;
    category_id: string;
    tags: string[];
    requirements: string[];
    what_you_learn: string[];
    is_featured: boolean;
    is_free: boolean;
    enrollment_count: number;
    rating: number;
    rating_count: number;
    lesson_count: number;
    created_at: Date;
    updated_at: Date;
  }
  
  export const createCourse = (data: Partial<Course>): Course => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    title: data.title || '',
    description: data.description || '',
    short_description: data.short_description || '',
    thumbnail: data.thumbnail || '',
    video_url: data.video_url || '',
    price: data.price ?? 0,
    original_price: data.original_price ?? 0,
    level: data.level || 'beginner',
    duration: data.duration ?? 0,
    language: data.language || 'es',
    status: data.status || 'draft',
    author_id: data.author_id || '',
    category_id: data.category_id || '',
    tags: data.tags || [],
    requirements: data.requirements || [],
    what_you_learn: data.what_you_learn || [],
    is_featured: data.is_featured ?? false,
    is_free: data.is_free ?? false,
    enrollment_count: data.enrollment_count ?? 0,
    rating: data.rating ?? 0,
    rating_count: data.rating_count ?? 0,
    lesson_count: data.lesson_count ?? 0,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
  });
  