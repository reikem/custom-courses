export interface Certificate{
    id:string;
    user_id:string;
    course_id:string;
    issued_at: Date;
    verification_code: string;
    certificate_url: string;
    final_score: number;
    is_valid: boolean;
}

export const createCertificate = (data: Partial<Certificate>): Certificate => ({
    id: data.id || crypto.randomUUID?.() || Math.random().toString(36).substring(2),
    user_id: data.user_id ?? '',
    course_id: data.course_id ?? '',
    issued_at: data.issued_at || new Date(),
    verification_code: data.verification_code || '',
    certificate_url: data.certificate_url || '',
    final_score: data.final_score ?? 0,
    is_valid: data.is_valid ?? true,
});