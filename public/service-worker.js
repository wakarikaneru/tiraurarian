const CACHE_NAME = "tirauraria-cache-v0";

console.log('Hello from service-worker.js');

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll([
        '/info/offline',
        '/images/no-image.png'
      ]);
    })
  );
});

self.addEventListener('fetch', (event) => {
  const requestURL = new URL(event.request.url);
  const destination = event.request.destination;
  console.log('event.request.url = ' + requestURL);
  console.log('event.request.destination = ' + destination);

  switch (destination) {
    case 'style':
    case 'script':
    case 'font': {
      //Cache, falling back to network
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return cache.match(event.request).then((cacheResponse) => {
            return cacheResponse || fetch(event.request).then((fetchResponse) => {
              if (!fetchResponse.ok || fetchResponse.type !== 'basic') {
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
    case 'image':{
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return fetch(event.request).catch(() => {
            return cache.match('/images/no-image.png');
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
            if (!fetchResponse.ok || fetchResponse.type !== 'basic') {
              return fetchResponse;
            }else{
              cache.put(event.request, fetchResponse.clone());
              return fetchResponse;
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
      return;
    }
  }
});
