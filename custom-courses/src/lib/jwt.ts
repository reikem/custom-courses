import jwt from 'jsonwebtoken'

const secret = process.env.JWT_SECRET!

export function signToken(payload: object) {
  return jwt.sign(payload, secret, { expiresIn: '24h' })
}

export function verifyToken(token: string) {
  return jwt.verify(token, secret)
}