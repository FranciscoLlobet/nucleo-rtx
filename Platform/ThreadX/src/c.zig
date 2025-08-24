// Copyright 2025 Francisco Llobet-Blandino
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
pub const c = @cImport({
    @cInclude("tx_api.h");
    @cInclude("tx_thread.h");
    @cInclude("tx_mutex.h");
    @cInclude("tx_semaphore.h");
    @cInclude("tx_queue.h");
    @cInclude("tx_event_flags.h");
    @cInclude("tx_timer.h");
    @cInclude("tx_byte_pool.h");
    @cInclude("tx_block_pool.h");
});
