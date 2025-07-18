export interface Category {
    id: string;
    name: string;
    description?: string;
    slug: string;
    icon?: string;
    color?: string;
    is_active: boolean;
    created_at: Date;
    updated_at: Date;
  }
  
  export const createCategory = (data: Partial<Category>): Category => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    name: data.name || '',
    description: data.description || '',
    slug: data.slug || '',
    icon: data.icon || '',
    color: data.color || '',
    is_active: data.is_active ?? true,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
  });
  