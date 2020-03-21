self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.open('tirauraria.me').then((cache) => {
      fetch(event.request).then((response) => {
        cache.put(event.request, response.clone());
        return response || cache.match(event.request);
      })
    })
  );
});
