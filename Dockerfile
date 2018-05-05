FROM daocloud.io/library/golang:1.8rc3-alpine

WORKDIR /app/gopath/mdblog
ENV GOPATH /app/gopath

RUN git clone --depth 1 git://github.com/eijan/blog.git . && go get -u github.com/toukii/mdbgEg && mv $GOPATH/bin/mdbgEg /bin/mdbgEg

EXPOSE 80

CMD ["/bin/mdbgEg"]


