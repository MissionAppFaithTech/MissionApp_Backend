-- CreateEnum
CREATE TYPE "public"."AuthenticationStatusType" AS ENUM ('SUCCESS', 'USER_NOT_EXISTS', 'INCORRECT_PASSWORD', 'BLOCKED');

-- CreateEnum
CREATE TYPE "public"."UserRoleType" AS ENUM ('ADMIN', 'MISSIONARY', 'DEFAULT');

-- CreateEnum
CREATE TYPE "public"."IdentityType" AS ENUM ('CPF', 'PASSPORT');

-- CreateEnum
CREATE TYPE "public"."GenderType" AS ENUM ('MALE', 'FEMALE');

-- CreateTable
CREATE TABLE "public"."authentication_audits" (
    "id" SERIAL NOT NULL,
    "ip_address" INET,
    "remote_port" TEXT,
    "browser" TEXT,
    "status" "public"."AuthenticationStatusType" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INTEGER,

    CONSTRAINT "authentication_audits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."users" (
    "id" SERIAL NOT NULL,
    "public_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "profile_picture" TEXT,
    "biography" TEXT,
    "role" "public"."UserRoleType" NOT NULL DEFAULT 'DEFAULT',
    "gender" "public"."GenderType",
    "followers_count" INTEGER NOT NULL DEFAULT 0,
    "following_count" INTEGER NOT NULL DEFAULT 0,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "login_attempts" INTEGER NOT NULL DEFAULT 0,
    "last_login" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "faith_community_id" INTEGER,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."missionaries" (
    "id" SERIAL NOT NULL,
    "public_email" TEXT,
    "public_phone" TEXT,
    "identity_type" "public"."IdentityType",
    "identity_document" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "missionaryAgencyId" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "missionaries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."work_addresses" (
    "id" SERIAL NOT NULL,
    "district" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "missionaryId" INTEGER NOT NULL,

    CONSTRAINT "work_addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."addresses" (
    "id" SERIAL NOT NULL,
    "zip" TEXT NOT NULL,
    "district" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "missionaryId" INTEGER NOT NULL,

    CONSTRAINT "addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."followers" (
    "follower_id" INTEGER NOT NULL,
    "following_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "followers_pkey" PRIMARY KEY ("follower_id","following_id")
);

-- CreateTable
CREATE TABLE "public"."faith_communities" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INTEGER,

    CONSTRAINT "faith_communities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."missionary_agencies" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "missionary_id" INTEGER,

    CONSTRAINT "missionary_agencies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."pastors" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "faithCommunityId" INTEGER NOT NULL,

    CONSTRAINT "pastors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."posts" (
    "id" SERIAL NOT NULL,
    "content" TEXT NOT NULL,
    "highlight_link" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "missionary_id" INTEGER NOT NULL,

    CONSTRAINT "posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."post_images" (
    "id" SERIAL NOT NULL,
    "imageURL" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "post_id" INTEGER NOT NULL,

    CONSTRAINT "post_images_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_public_id_key" ON "public"."users"("public_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "public"."users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "public"."users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "missionaries_user_id_key" ON "public"."missionaries"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "work_addresses_missionaryId_key" ON "public"."work_addresses"("missionaryId");

-- CreateIndex
CREATE UNIQUE INDEX "addresses_missionaryId_key" ON "public"."addresses"("missionaryId");

-- CreateIndex
CREATE INDEX "followers_following_id_idx" ON "public"."followers"("following_id");

-- CreateIndex
CREATE INDEX "followers_follower_id_idx" ON "public"."followers"("follower_id");

-- CreateIndex
CREATE INDEX "posts_missionary_id_created_at_idx" ON "public"."posts"("missionary_id", "created_at");

-- CreateIndex
CREATE INDEX "post_images_post_id_idx" ON "public"."post_images"("post_id");

-- AddForeignKey
ALTER TABLE "public"."authentication_audits" ADD CONSTRAINT "authentication_audits_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."users" ADD CONSTRAINT "users_faith_community_id_fkey" FOREIGN KEY ("faith_community_id") REFERENCES "public"."faith_communities"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."missionaries" ADD CONSTRAINT "missionaries_missionaryAgencyId_fkey" FOREIGN KEY ("missionaryAgencyId") REFERENCES "public"."missionary_agencies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."missionaries" ADD CONSTRAINT "missionaries_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."work_addresses" ADD CONSTRAINT "work_addresses_missionaryId_fkey" FOREIGN KEY ("missionaryId") REFERENCES "public"."missionaries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."addresses" ADD CONSTRAINT "addresses_missionaryId_fkey" FOREIGN KEY ("missionaryId") REFERENCES "public"."missionaries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."followers" ADD CONSTRAINT "followers_follower_id_fkey" FOREIGN KEY ("follower_id") REFERENCES "public"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."followers" ADD CONSTRAINT "followers_following_id_fkey" FOREIGN KEY ("following_id") REFERENCES "public"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."faith_communities" ADD CONSTRAINT "faith_communities_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."missionary_agencies" ADD CONSTRAINT "missionary_agencies_missionary_id_fkey" FOREIGN KEY ("missionary_id") REFERENCES "public"."missionaries"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."pastors" ADD CONSTRAINT "pastors_faithCommunityId_fkey" FOREIGN KEY ("faithCommunityId") REFERENCES "public"."faith_communities"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."posts" ADD CONSTRAINT "posts_missionary_id_fkey" FOREIGN KEY ("missionary_id") REFERENCES "public"."missionaries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."post_images" ADD CONSTRAINT "post_images_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE CASCADE ON UPDATE CASCADE;
