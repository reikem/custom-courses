export interface User {
  id: string
  email: string
  name: string
  avatar?: string
  role: 'student' | 'instructor' | 'admin'
  password_hash: string
  password_changed_at?: Date
  bio?: string
  website?: string
  location?: string
  phone?: string
  birth_date?: Date
  is_active: boolean
  email_verified: boolean
  last_login?: Date
  created_at: Date
  updated_at: Date
}

export const createUser = (data: Partial<User>): User => ({
  id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
  email: data.email || '',
  name: data.name || '',
  avatar: data.avatar,
  role: data.role || 'student',
  password_hash: data.password_hash || '',
  password_changed_at: data.password_changed_at,
  bio: data.bio,
  website: data.website,
  location: data.location,
  phone: data.phone,
  birth_date: data.birth_date,
  is_active: data.is_active ?? true,
  email_verified: data.email_verified ?? false,
  last_login: data.last_login,
  created_at: data.created_at || new Date(),
  updated_at: data.updated_at || new Date(),
})
