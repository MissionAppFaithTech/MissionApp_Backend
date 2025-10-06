import '@fastify/jwt'
import 'fastify'
import type { MembershipStatusType, UserRoleType } from '@prisma/client'

declare module '@fastify/jwt' {
  export interface FastifyJWT {
    user: {
      role: UserRoleType
      status: MembershipStatusType
      sub: string
    }
  }
}
