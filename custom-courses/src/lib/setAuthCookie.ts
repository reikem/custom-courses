import { serialize } from 'cookie'
import { encrypt } from './encryption'

export function createSecureCookies(token: string, userPayload: object) {
  const maxAge = 60 * 60 * 24 // 24h
  const cookieTokenName = process.env.AUTH_COOKIE_NAME || 'auth_token'
  const cookieDataName = process.env.AUTH_DATA_COOKIE_NAME || 'auth_data'

  const encryptedUser = encrypt(JSON.stringify(userPayload))

  const tokenCookie = serialize(cookieTokenName, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/',
    maxAge,
  })

  const dataCookie = serialize(cookieDataName, encryptedUser, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/',
    maxAge,
  })

  return [tokenCookie, dataCookie]
}
