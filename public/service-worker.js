console.log('Hello from service-worker.js');

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.open('tirauraria-v1').then((cache) => {
      event.updateUI({ title: 'download finished' });
      return fetch(event.request).then((response) => {
        cache.put(event.request, response.clone());
        return response;
      }).catch(() => {
        return cache.match(event.request);
      })
    })
  );
});
