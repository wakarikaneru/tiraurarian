self.addEventListener('fetch', function(event) {
  event.respondWith(
    fetch(event.request).catch(function() {
      return caches.match(event.request);
    })
  );
});

self.addEventListener('backgroundfetchsuccess', function(event) {
  const bgFetch = event.registration;

  event.waitUntil(async function() {
    // Create/open a cache.
    const cache = await caches.open('downloads');
    // Get all the records.
    const records = await bgFetch.matchAll();
    // Copy each request/response across.
    const promises = records.map(async (record) => {
      const response = await record.responseReady;
      await cache.put(record.request, response);
    });

    // Wait for the copying to complete.
    await Promise.all(promises);

    // Update the progress notification.
    event.updateUI({ title: 'Episode 5 ready to listen!' });
  }());
});

self.addEventListener('notificationclick', function(event) {
  console.log('[Service Worker] Notification click Received.');

  event.notification.close();

  event.waitUntil(
    clients.openWindow('https://developers.google.com/web/')
  );
});
