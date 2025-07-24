import jwt from 'jsonwebtoken'
import { serialize, parse } from 'cookie'
import { NextApiResponse, NextApiRequest } from 'next'

const JWT_SECRET = process.env.JWT_SECRET || 'default_secret'
const COOKIE_NAME = process.env.COOKIE_NAME || 'learn_auth_token'

export interface AuthPayload {
  userId: string
  email: string
  role: 'admin' | 'instructor' | 'student'
}


export function signToken(payload: AuthPayload): string {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: '24h' })
}


export function verifyToken(token: string): AuthPayload {
  return jwt.verify(token, JWT_SECRET) as AuthPayload
}


export function setAuthCookie(res: NextApiResponse, token: string) {
  const cookie = serialize(COOKIE_NAME, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/',
    maxAge: 60 * 60 * 24 * 5, // 5 días
  })

  res.setHeader('Set-Cookie', cookie)
}


export function getAuthCookie(req: NextApiRequest): string | null {
  const cookies = parse(req.headers.cookie || '')
  return cookies[COOKIE_NAME] || null
}


export function removeAuthCookie(res: NextApiResponse) {
  const cookie = serialize(COOKIE_NAME, '', {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/',
    maxAge: 0,
  })

  res.setHeader('Set-Cookie', cookie)
}
