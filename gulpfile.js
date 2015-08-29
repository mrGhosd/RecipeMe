var gulp = require('gulp');
var util = require('gulp-util');
var watchify = require('watchify');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var browserify = require('browserify');
var coffeeify = require('coffeeify');
var source = require('vinyl-source-stream');
var _ = require('lodash');
var $ = require('jquery');
var bower = require('gulp-bower');

var config = {
    bowerDir: './bower_components'
};

function browserifyInstance(fileName, userOpts) {
    if(!userOpts) {
        userOpts = {};
    }

    var defaultOpts = {
        extensions: ['.coffee', '.js', '.js.coffee']
    };

    return browserify(fileName, _.assign(defaultOpts, userOpts))
}


gulp.task('watch-sass', function() {
    gulp.watch('app/assets/stylesheets/**/*.sass', ['compile-sass']);
});

gulp.task('watch-scss', function() {
    gulp.watch('app/assets/stylesheets/**/*.scss', ['compile-scss']);
});

gulp.task('watch-coffee', function() {
    var watchBrowserify = watchify(browserifyInstance('./app/assets/javascripts/application.js', _.assign(watchify.args, { debug: true })));

    var updateOnChange = function() {
        return watchBrowserify
            .bundle()
            .on('error', util.log.bind(util, 'Browserify Error'))
            .pipe(source('bundle.js'))
            .pipe(gulp.dest('public/assets'));
    };

    watchBrowserify
        .transform('coffeeify')
        .on('log', util.log)
        .on('update', updateOnChange)
    updateOnChange();
});

gulp.task('compile-sass', function() {
    gulp.src('app/assets/stylesheets/**/*.sass')
        .pipe(sourcemaps.init())
        .pipe(sass({ indentedSyntax: true, errLogToConsole: true }))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('public/assets'));
});

gulp.task('compile-scss', function() {
    gulp.src('app/assets/stylesheets/**/*.css.scss')
        .pipe(sourcemaps.init())
        .pipe(sass({
            style: 'compressed',
            indentedSyntax: false, errLogToConsole: true,
            loadPath: [
                './app/assets/stylesheets',
                config.bowerDir + '/bootstrap-sass-official/assets/stylesheets',
                config.bowerDir + '/fontawesome/scss'
            ]}))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('public/assets'));
});

gulp.task('compile-coffee', function() {
    var stream = browserifyInstance('./app/assets/javascripts/application.js',
        { debug: true /* enables source maps */ }
    )
        .transform('coffeeify')
        .bundle();

    stream.pipe(source('bundle.js'))
        .pipe(gulp.dest('public/assets'));
});

gulp.task('bower', function() {
    return bower()
        .pipe(gulp.dest(config.bowerDir))
});

gulp.task('icons', function() {
    return gulp.src(config.bowerDir + '/fontawesome/fonts/**.*')
        .pipe(gulp.dest('./public/fonts'));
});

gulp.task('default', ['bower', 'icons', 'compile-sass', 'compile-scss', 'compile-coffee']);
gulp.task('watch', ['watch-sass', 'watch-scss', 'watch-coffee']);