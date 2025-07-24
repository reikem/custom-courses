export interface Achievements{
    id:string;
    name:string;
    description?:string;
    icon?:string;
    category_id:string;
    points:number;
    is_active:boolean;
    created_at:Date;
    updated_at:Date;
}
export const createAchievement = (data: Partial<Achievements>): Achievements => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    name: data.name || '',
    description: data.description || '',
    icon: data.icon || '',
    category_id: data.category_id || '',
    points: data.points ?? 0,
    is_active: data.is_active ?? true,
    created_at: data.created_at || new Date(),
    updated_at: data.updated_at || new Date(),
});