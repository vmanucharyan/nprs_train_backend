module Errors
  class AppError < StandardError; end
  class ImageAlreadyLocked < StandardError; end
  class LockValidationFailed < StandardError; end
end
