'use client'

import { useState } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'
import type { Notification } from '@/types'

interface NotificationListProps {
  initialNotifications: Notification[]
  userId: string
}

export default function NotificationList({ initialNotifications, userId }: NotificationListProps) {
  const [notifications, setNotifications] = useState(initialNotifications)
  const [filter, setFilter] = useState<'all' | 'unread'>('all')
  const supabase = createClient()

  const filteredNotifications = filter === 'unread'
    ? notifications.filter((n) => !n.is_read)
    : notifications

  const unreadCount = notifications.filter((n) => !n.is_read).length

  const markAsRead = async (notificationId: string) => {
    await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('id', notificationId)

    setNotifications((prev) =>
      prev.map((n) => (n.id === notificationId ? { ...n, is_read: true } : n))
    )
  }

  const markAllAsRead = async () => {
    await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('user_id', userId)
      .eq('is_read', false)

    setNotifications((prev) => prev.map((n) => ({ ...n, is_read: true })))
  }

  const deleteNotification = async (notificationId: string) => {
    await supabase
      .from('notifications')
      .delete()
      .eq('id', notificationId)

    setNotifications((prev) => prev.filter((n) => n.id !== notificationId))
  }

  const deleteAllRead = async () => {
    await supabase
      .from('notifications')
      .delete()
      .eq('user_id', userId)
      .eq('is_read', true)

    setNotifications((prev) => prev.filter((n) => !n.is_read))
  }

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'reply':
        return '💬'
      case 'mention':
        return '@'
      case 'announcement':
        return '📢'
      case 'grade':
        return '📊'
      case 'reminder':
        return '⏰'
      case 'answer':
        return '✅'
      default:
        return '🔔'
    }
  }

  const formatDate = (date: string) => {
    return new Date(date).toLocaleDateString('es-ES', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  return (
    <div>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-4">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filter === 'all'
                ? 'bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 text-rizoma-green-dark dark:text-rizoma-green-light'
                : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700'
            }`}
          >
            Todas ({notifications.length})
          </button>
          <button
            onClick={() => setFilter('unread')}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filter === 'unread'
                ? 'bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 text-rizoma-green-dark dark:text-rizoma-green-light'
                : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700'
            }`}
          >
            Sin leer ({unreadCount})
          </button>
        </div>

        <div className="flex items-center gap-3">
          {unreadCount > 0 && (
            <button
              onClick={markAllAsRead}
              className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline"
            >
              Marcar todas como leidas
            </button>
          )}
          {notifications.some((n) => n.is_read) && (
            <button
              onClick={deleteAllRead}
              className="text-sm text-red-600 dark:text-red-400 hover:underline"
            >
              Eliminar leidas
            </button>
          )}
        </div>
      </div>

      {/* Notifications */}
      {filteredNotifications.length > 0 ? (
        <div className="space-y-3">
          {filteredNotifications.map((notification) => (
            <div
              key={notification.id}
              className={`bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm border transition-colors ${
                !notification.is_read
                  ? 'border-rizoma-green/20 dark:border-rizoma-green-dark bg-rizoma-green/5/30 dark:bg-rizoma-green-dark/10'
                  : 'border-gray-200 dark:border-gray-700'
              }`}
            >
              <div className="flex items-start gap-4">
                <span className="text-2xl flex-shrink-0">
                  {getNotificationIcon(notification.type)}
                </span>

                <div className="flex-1 min-w-0">
                  <div className="flex items-start justify-between gap-4">
                    <div>
                      <h3 className={`text-gray-900 dark:text-white ${!notification.is_read ? 'font-semibold' : ''}`}>
                        {notification.title}
                      </h3>
                      {notification.content && (
                        <p className="text-gray-600 dark:text-gray-400 text-sm mt-1">
                          {notification.content}
                        </p>
                      )}
                      <p className="text-sm text-gray-500 dark:text-gray-500 mt-2">
                        {formatDate(notification.created_at)}
                      </p>
                    </div>

                    {!notification.is_read && (
                      <span className="w-2 h-2 bg-rizoma-green rounded-full flex-shrink-0 mt-2" />
                    )}
                  </div>

                  <div className="flex items-center gap-4 mt-3 pt-3 border-t border-gray-100 dark:border-gray-700">
                    {notification.related_url && (
                      <Link
                        href={notification.related_url}
                        onClick={() => markAsRead(notification.id)}
                        className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline"
                      >
                        Ver detalle
                      </Link>
                    )}
                    {!notification.is_read && (
                      <button
                        onClick={() => markAsRead(notification.id)}
                        className="text-sm text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200"
                      >
                        Marcar como leida
                      </button>
                    )}
                    <button
                      onClick={() => deleteNotification(notification.id)}
                      className="text-sm text-red-500 hover:text-red-700 dark:hover:text-red-300"
                    >
                      Eliminar
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center py-12 bg-gray-50 dark:bg-gray-800/50 rounded-xl">
          <span className="text-5xl block mb-4">🔔</span>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
            {filter === 'unread' ? 'No tienes notificaciones sin leer' : 'No tienes notificaciones'}
          </h3>
          <p className="text-gray-600 dark:text-gray-400">
            Las notificaciones de tus cursos apareceran aqui
          </p>
        </div>
      )}
    </div>
  )
}
