import { PrismaClient } from '@prisma/client'
import { faithCommunityData_1 } from './seed-data/faith-communities'
import { pastorData_1 } from './seed-data/pastors'
import { userData_1 } from './seed-data/users'

const prisma = new PrismaClient()

async function main() {
  // Criação da FaithCommunity:
  let faithCommunity = await prisma.faithCommunity.findFirst({
    where: faithCommunityData_1,
  })

  if (!faithCommunity) {
    faithCommunity = await prisma.faithCommunity.create({
      data: faithCommunityData_1,
    })
  }

  // Criação do Pastor:
  let pastor = await prisma.pastor.findFirst({
    where: pastorData_1,
  })

  if (!pastor) {
    pastor = await prisma.pastor.create({
      data: {
        ...pastorData_1,
        faithCommunityId: faithCommunity.id,
      },
    })
  }

  // Criação do User:
  const user = await prisma.user.upsert({
    where: { email: userData_1.email },
    update: {},
    create: {
      ...userData_1,
      faithCommunityId: 1,
    },
  })

  // Criação da MissionaryAgency:
  const missionaryAgencyData = {
    name: 'Agência de Missionários',
  }

  let missionaryAgency = await prisma.missionaryAgency.findFirst({
    where: missionaryAgencyData,
  })

  if (missionaryAgency === null) {
    missionaryAgency = await prisma.missionaryAgency.create({
      data: missionaryAgencyData,
    })
  }

  // Adicionando informações de Missionary ao User:
  const missionaryData = {
    publicEmail: 'missionApp-missionary@email.com',
    publicPhoneNumber: '+55 21 98765-4321',
  }

  await prisma.missionary.upsert({
    where: { userId: user.id },
    update: { userId: user.id },
    create: {
      ...missionaryData,
      userId: user.id,
      missionaryAgencyId: missionaryAgency.id,
    },
  })

  // Atualizando FaithCommunity para referenciar o User criador:
  await prisma.faithCommunity.update({
    where: { id: faithCommunity.id },
    data: {
      userId: user.id,
    },
  })
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (error) => {
    // eslint-disable-next-line no-console
    console.error('Erro ao executar seed:', error)
    await prisma.$disconnect()
    process.exit(1)
  })
