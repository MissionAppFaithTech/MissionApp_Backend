import { IS_DEBUG } from '@constants/env-constants'
import { logger } from '@lib/logger'
import { PG_TRGM_NOT_ENABLED } from '@messages/logger'
import type { PrismaClient } from '@prisma/client'

export async function ensurePgTrgmAvailable(prisma: PrismaClient) {
  const response: Array<{ extname: string }> = await prisma.$queryRaw`
    SELECT extname FROM pg_extension WHERE extname = 'pg_trgm'
  `

  if (response.length === 0 && IS_DEBUG) {
    logger.warn(PG_TRGM_NOT_ENABLED)
    return false
  }

  if (IS_DEBUG) {
    if (response.length === 0) {
      logger.warn(PG_TRGM_NOT_ENABLED)
      return false
    }

    // Testar similarity:
    const similarity = await prisma.$queryRaw<
      Array<{ similarity: number }>
    >`SELECT similarity('astrology', 'astrobiology') as similarity`
    logger.info(`pg_trgm similarity check: ${similarity[0].similarity}`)

    const result = await prisma.$queryRaw<Array<{ similar: boolean; score: number }>>`
      SELECT
        similarity(${`banana`}, ${`bananas`}) AS score,
        ${`banana`} % ${`bananas`} AS similar;
    `

    logger.info(`Result: { score: ${result[0].score}, similar: ${result[0].similar} }`)
  }

  return true
}
