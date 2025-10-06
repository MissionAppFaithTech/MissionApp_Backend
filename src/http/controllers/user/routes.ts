import type { FastifyInstance } from 'fastify'
import { authenticate } from './authenticate.controller'
import { refreshToken } from './refresh-token.controller'
import { verifyJwt } from '@middlewares/verify-jwt.middleware'

export async function userRoutes(app: FastifyInstance) {
  app.post('/sessions', authenticate)

  app.post(
    '/sessions/refresh-token',
    {
      preHandler: [verifyJwt],
    },
    refreshToken,
  )
}
