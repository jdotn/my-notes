## async
関数,メソッドの前に記述することで,とえその関数内でPromiseが返されていなくても
戻り値の型をPromiseにラップして戻す.
また,async関数,メソッドの中ではawaitを使うこともできる.

```typescript
async function requestAsync(): Promise<number> {
  return 1;
}
```
 
```typescript
const fetchAsync = async (): Promise<number> => {
  return 1;
};
```

よって,以下の2つの関数はである.
```typescript
async function requestAsync(): Promise<number> {
  return 1;
}
 
function request(): Promise<number> {
  return new Promise((resolve) => {
    resolve(1);
  });
}
```

asyncは元々Promiseが返る関数に対しても付加が可能であり,
そのときに戻り値の型はPromise<Promise<T>>のように二重にはならず,
Promise<T>となる.
```typescript
async function requestAsync(): Promise<number> {
  return new Promise((resolve) => {
    resolve(1);
  });
}
```

async関数,メソッドを拒否(reject)するには,その中でthrowを使うだけでよい.
```typescript
async function requestAsync(): Promise<number> {
  throw new Error("error");
}
```
