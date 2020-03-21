self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.open('tirauraria-v1').then((cache) => {
       return fetch(event.request).then((response) => {
        cache.put(event.request, response.clone());
        return response;
      }).catch(() => {
        return cache.match(event.request);
      })
    })
  );
});
