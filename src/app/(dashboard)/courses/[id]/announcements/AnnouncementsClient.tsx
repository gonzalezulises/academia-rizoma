'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { AnnouncementCard, CreateAnnouncement } from '@/components/announcements'
import type { AnnouncementWithAuthor, Announcement, Profile } from '@/types'

interface AnnouncementsClientProps {
  courseId: string
  userId: string
  profile: Profile | null
  isInstructor: boolean
  initialAnnouncements: AnnouncementWithAuthor[]
}

export default function AnnouncementsClient({
  courseId,
  userId,
  profile,
  isInstructor,
  initialAnnouncements
}: AnnouncementsClientProps) {
  const [announcements, setAnnouncements] = useState(initialAnnouncements)
  const [showForm, setShowForm] = useState(false)
  const supabase = createClient()

  const handleCreated = (newAnnouncement: Announcement) => {
    const announcementWithAuthor: AnnouncementWithAuthor = {
      ...newAnnouncement,
      author: profile!
    }

    // Add to list (pinned first, then by date)
    setAnnouncements((prev) => {
      const updated = [announcementWithAuthor, ...prev]
      return updated.sort((a, b) => {
        if (a.is_pinned !== b.is_pinned) return a.is_pinned ? -1 : 1
        return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
      })
    })

    setShowForm(false)
  }

  const handleDelete = async (announcementId: string) => {
    if (!confirm('¿Estas seguro de eliminar este anuncio?')) return

    const { error } = await supabase
      .from('announcements')
      .delete()
      .eq('id', announcementId)

    if (!error) {
      setAnnouncements((prev) => prev.filter((a) => a.id !== announcementId))
    }
  }

  return (
    <div>
      {/* Create announcement button/form */}
      {isInstructor && (
        <div className="mb-6">
          {showForm ? (
            <CreateAnnouncement
              courseId={courseId}
              userId={userId}
              onCreated={handleCreated}
              onCancel={() => setShowForm(false)}
            />
          ) : (
            <button
              onClick={() => setShowForm(true)}
              className="w-full py-4 border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-xl text-gray-600 dark:text-gray-400 hover:border-rizoma-green hover:text-rizoma-green transition-colors"
            >
              + Crear nuevo anuncio
            </button>
          )}
        </div>
      )}

      {/* Announcements list */}
      {announcements.length > 0 ? (
        <div className="space-y-4">
          {announcements.map((announcement) => (
            <AnnouncementCard
              key={announcement.id}
              announcement={announcement}
              isInstructor={isInstructor}
              onDelete={() => handleDelete(announcement.id)}
            />
          ))}
        </div>
      ) : (
        <div className="text-center py-12 bg-gray-50 dark:bg-gray-800/50 rounded-xl">
          <span className="text-5xl block mb-4">📢</span>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
            No hay anuncios
          </h3>
          <p className="text-gray-600 dark:text-gray-400">
            {isInstructor
              ? 'Crea un anuncio para comunicarte con tus estudiantes'
              : 'Los anuncios del instructor apareceran aqui'}
          </p>
        </div>
      )}
    </div>
  )
}
