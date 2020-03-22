let CACHE_NAME = "tirauraria-cache-v0"

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
  const destination = event.request.destination;

  switch (destination) {
    case 'style':
    case 'script':{
      //stale-while-revalidate
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return cache.match(event.request).then((cacheResponse) => {
            var fetchPromise = fetch(event.request).then((fetchResponse) => {
              cache.put(event.request, fetchResponse.clone());
              return fetchResponse;
            })
            return cacheResponse || fetchPromise;
          })
        })
      );
      return;
    }
    case 'font':
    case 'image':{
      //Cache, falling back to network
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return cache.match(event.request).then((cacheResponse) => {
            return cacheResponse || fetch(event.request).then((fetchResponse) => {
              if (!fetchResponse || fetchResponse.status !== 200 || fetchResponse.type !== 'basic') {
                return fetchResponse;
              }else{
                cache.put(event.request, fetchResponse.clone());
                return fetchResponse;
              }
            });
          })
        })
      );
      return;
    }
    default: {
      //Network falling back to cache, Generic fallback
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return fetch(event.request).then((fetchResponse) => {
            if (!fetchResponse || fetchResponse.status !== 200 || fetchResponse.type !== 'basic') {
              return fetchResponse;
            }else{
              cache.put(event.request, fetchResponse.clone());
              return fetchResponse;
            }
          }).catch(() => {
            return cache.match(event.request) || cache.match('/info/offline');
          })
        })
      );
      return;
    }
  }
});
