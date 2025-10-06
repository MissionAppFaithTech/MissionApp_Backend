import { logger } from '@lib/logger'
import { setUserId } from '@lib/logger/helpers/set-user-id'
import { INACTIVE_USER, UNAUTHORIZED } from '@messages/response'
import { MembershipStatusType } from '@prisma/client'
import type { FastifyReply, FastifyRequest } from 'fastify'

export async function verifyJwt(request: FastifyRequest, reply: FastifyReply) {
  try {
    await request.jwtVerify()
    setUserId(request.user.sub)
  } catch (error) {
    logger.debug(UNAUTHORIZED.body)
    return await reply.status(UNAUTHORIZED.status).send(UNAUTHORIZED.body)
  }

  const { status } = request.user

  if (status === MembershipStatusType.INACTIVE) {
    return await reply.status(INACTIVE_USER.status).send(INACTIVE_USER.body)
  }
}
