let CACHE_NAME = "tirauraria-v1"

console.log('Hello from service-worker.js');

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll([
        '/info/offline'
      ]);
    })
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.open(CACHE_NAME).then((cache) => {
      return fetch(event.request).then((response) => {
        if (!response || response.status !== 200 || response.type !== 'basic') {
          return response;
        }else{
          cache.put(event.request, response.clone());
          return response;
        }
      }).catch(() => {
        return cache.match(event.request).then((cachedResponse) => {
          if(cachedResponse){
            return cachedResponse;
          }else{
            return cache.match('/info/offline');
          }
        })
      })
    })
  );
});
