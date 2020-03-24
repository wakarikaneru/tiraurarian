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
              if (fetchResponse.ok) {
                cache.put(event.request, fetchResponse.clone());
                console.log("cache.put " + event.request);
                return fetchResponse;
              }else{
                return fetchResponse;
              }
            });
          })
        })
      );
      break;
    }
    case 'image':{
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return fetch(event.request).catch(() => {
            return cache.match('/images/no-image.png');
          })
        })
      );
      break;
    }
    case 'document':{
      event.respondWith(fetch(event.request));
    }
    default: {
      //Network falling back to cache, Generic fallback
      event.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
          return fetch(event.request).then((fetchResponse) => {
            const contentType = fetchResponse.clone().headers.get('Content-Type');
            console.log("fetchResponse.headers.get('Content-Type') = " + contentType);
            console.log("contentType.includes('text/html') " + contentType.includes('text/html'));

            if (contentType.includes('text/html')){
              if (fetchResponse.ok) {
                cache.put(event.request, fetchResponse.clone());
                console.log("cache.put " + event.request.url);
                return fetchResponse;
              }else{
                return cache.match(event.request).then((cachedResponse) => {
                  if(cachedResponse){
                    return cachedResponse;
                  }else{
                    return cache.match('/info/offline');
                  }
                });
              }
            }else{
              return fetchResponse;
            }

          })
        })
      );
      break;
    }
  }
});
