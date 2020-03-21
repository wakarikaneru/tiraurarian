self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.open('tirauraria.me-v1').then((cache) => {
      fetch(event.request).then((response) => {
        cache.put(event.request, response.clone());
        return response;
      }).catch(() => {
        return cache.match(event.request);
      })
    })
  );
});
